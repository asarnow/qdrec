package edu.sfsu.ntd.phenometrainer

class Users {

	transient springSecurityService

  static hasMany = [trainedParasites: ParasiteTrainState]
//  static hasOne = [lastImage: Image]

	String username
	String password
  Date dateCreated
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
  SubsetImage lastImageSubset

	static constraints = {
		username blank: false, unique: true
		password blank: false
	}

	static mapping = {
		password column: '`password`'
	}

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role } as Set
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}
}
