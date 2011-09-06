module Grim
  class Pdf
    attr_accessor :path

    # Raises an error if pdf not found and sets some instance
    # variables if pdf is found.
    #
    # path - A String or Path to the pdf
    #
    def initialize(path)
      raise Grim::PdfNotFound unless File.exists?(path)
      @path = path
    end

    # Shells out to ghostscript to read the pdf with the pdf_info.ps script
    # as a filter, returning the number of pages in the pdf as an integer.
    #
    # For example:
    #
    #   pdf.count
    #   # => 4
    #
    # Returns an Integer.
    #
    def count
      @count ||= begin
        `gs -dNODISPLAY -q -sFile=#{@path} ./lib/pdf_info.ps`.to_i
      end
    end

    # Creates an instance Grim::Page for the index passed in.
    #
    # index - accepts Integer for position in array
    #
    # For example:
    #
    #   pdf[4]  # returns 5th page
    #
    # Returns an instance of Grim::Page.
    #
    def [](index)
      raise Grim::PageNotFound unless index >= 0 && index < count
      Grim::Page.new(self, index)
    end
  end
end