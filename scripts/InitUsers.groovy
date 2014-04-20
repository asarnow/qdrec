/*
 * Copyright (c) 2013 Daniel Asarnow
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