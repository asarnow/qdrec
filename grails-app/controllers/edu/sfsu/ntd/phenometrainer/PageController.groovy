package edu.sfsu.ntd.phenometrainer

import com.mathworks.toolbox.javabuilder.MWCellArray
import phenomj.PhenomJ

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

    def unsupported() {
      render(view:'unsupported')
    }

    def listfonts() {
      def phenomj = new PhenomJ()
      Object[] out = phenomj.listfonts(1)
      def fonts_cell = (MWCellArray)(out[0])
      def fonts = fonts_cell.exportCells()
      render(fonts)
    }
}
