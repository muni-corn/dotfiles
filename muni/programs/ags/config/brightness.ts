class BrilloService extends Service {
  // every subclass of GObject.Object has to register itself
  static {
    // takes three arguments
    // the class itself
    // an object defining the signals
    // an object defining its properties
    Service.register(
      this,
      {
        // 'name-of-signal': [type as a string from GObject.TYPE_<type>],
        "screen-changed": ["float"],
      },
      {
        // 'kebab-cased-name': [type as a string from GObject.TYPE_<type>, 'r' | 'w' | 'rw']
        // 'r' means readable
        // 'w' means writable
        // guess what 'rw' means
        "screen-value": ["float", "rw"],
      },
    );
  }

  // this Service assumes only one device with backlight
  #interface = Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");

  #rawScreenValue = 0;
  #min = Number(Utils.exec("brillo -rc"));
  #max = Number(Utils.exec("brillo -rm"));

  get available() {
    return this.#interface.trim() !== "";
  }

  // the getter has to be in snake_case
  get screen_value() {
    return (100 * (this.#rawScreenValue - this.#min)) / (this.#max - this.#min);
  }

  // the setter has to be in snake_case too
  set screen_value(percent) {
    let raw_value = this.#min + ((this.#max - this.#min) * percent) / 100;
    if (raw_value < this.#min) raw_value = this.#min;
    else if (raw_value > this.#max) raw_value = this.#max;

    Utils.execAsync(`brillo -Sr ${raw_value}`);
    // the file monitor will handle the rest
  }

  constructor() {
    super();

    // setup monitor
    const brightness = `/sys/class/backlight/${this.#interface}/brightness`;
    Utils.monitorFile(brightness, () => this.#onChange());

    // initialize
    this.#onChange();
  }

  #onChange() {
    this.#rawScreenValue = Number(Utils.exec("brillo -rG"));

    // or use Service.changed(propName: string) which does the above two
    this.changed('screen-value');

    // emit screen-changed with the raw value as a parameter
    this.emit("screen-changed", this.screen_value);
  }

  // overwriting the connect method, let's you
  // change the default event that widgets connect to
  connect(
    event = "screen-changed",
    callback: (_: this, ...args: any[]) => void,
  ) {
    return super.connect(event, callback);
  }
}

// the singleton instance
const service = new BrilloService();

// export to use in other modules
export default service;
