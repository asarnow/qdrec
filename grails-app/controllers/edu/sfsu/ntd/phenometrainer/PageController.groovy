package edu.sfsu.ntd.phenometrainer

class PageController {

    def about() {
      render(view: 'about')
    }

    def help() {
      render(view:'help')
    }

    def unsupported() {
      render(view:'unsupported')
    }
}
