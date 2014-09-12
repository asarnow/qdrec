/*
 * Copyright (C) 2014
 * Daniel Asarnow
 * Rahul Singh
 * San Francisco State University
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import edu.sfsu.ntd.phenometrainer.Image

import edu.sfsu.ntd.phenometrainer.SubsetImage

/**
 *
 * @author Daniel Asarnow
 */
def bootStrapService = ctx.bootStrapService

    if (!Role.findByAuthority('ROLE_USER')) bootStrapService.initRole('ROLE_USER')
    if (!Role.findByAuthority('ROLE_ADMIN')) bootStrapService.initRole('ROLE_ADMIN')

    if (!Users.findByUsername('lili')) bootStrapService.initUser('lili','liliucsf','ROLE_USER')
    if (!Users.findByUsername('schisto')) bootStrapService.initUser('schisto','schisto','ROLE_USER')
    if (!Users.findByUsername('da')) bootStrapService.initUser('da','gh0stly','ROLE_USER')
    if (!Users.findByUsername('conor')) bootStrapService.initUser('conor','conorucsf','ROLE_USER')
    if (!Users.findByUsername('brian')) bootStrapService.initUser('brian','brianucsf','ROLE_USER')

    bootStrapService.addUserRole('da','ROLE_ADMIN')