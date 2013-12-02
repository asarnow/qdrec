package edu.sfsu.ntd.phenometrainer

class PageController {

    def help() {
      render(view:'help')
    }

    def unsupported() {
      render(view:'unsupported')
    }
}
