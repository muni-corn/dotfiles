db.createUser({
	user: "apollo",
	pwd: "defaultPass",
	roles: [{ role: "readWrite", db: "apollo_test" }],
});
