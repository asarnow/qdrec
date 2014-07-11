/*
 * Copyright (C) 2014 Daniel Asarnow
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

package edu.sfsu.ntd.phenometrainer
/**
 * Controller for static content. Each action (class methods) maps directly to
 * the URL of some static content - e.g. main page, about page, help pages.
 */
class PageController {

    def trainService

    def about() {
      trainService.saveCurrentImageState(session["parasites"])
      render(view: 'about')
    }

    def help() {
      trainService.saveCurrentImageState(session["parasites"])
      render(view:'help')
    }

    def home() {
      render(view: 'home')
    }

    def download() {
      render(view: 'download')
    }

    def tutorial() {
      render(view: 'tutorial')
    }

    def unsupported() {
      render(view:'unsupported')
    }

}
