/*
 * Copyright (C) 2014 Daniel Asarnow
 * San Francisco State University
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

