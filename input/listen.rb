require 'listen'


# A simple class that will help listen to file creations in a directory,
# and report them to a block.
class DirectoryListener

  def initialize(directory)
    @directory = directory
    @listener = Listen.to(directory) do |modified, added, removed|
      if not added.nil?
        yield added
      end
    end
  end
end