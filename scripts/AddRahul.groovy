/*
 * Copyright (c) 2013 Daniel Asarnow
 */

import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Role
import edu.sfsu.ntd.phenometrainer.SubsetImage
import edu.sfsu.ntd.phenometrainer.UserRole
import edu.sfsu.ntd.phenometrainer.Users

/**                                                                                                               3
 *
 * @author Daniel Asarnow
 */

def bootStrapService = ctx.bootStrapService

if (!Role.findByAuthority('ROLE_USER')) bootStrapService.initRole('ROLE_USER')
if (!Role.findByAuthority('ROLE_ADMIN')) bootStrapService.initRole('ROLE_ADMIN')

if (!Users.findByUsername('rahul')) bootStrapService.initUser('rahul','rahulsfsu','ROLE_USER')
bootStrapService.addUserRole('rahul','ROLE_ADMIN')

