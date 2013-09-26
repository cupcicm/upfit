
# Applies a post process step on an activity file.
class Processor

  def run(data)
    raise NotImplementedError
  end
end

class DoNothingProcessor < Processor

  def process(data)
    return data
  end
end
