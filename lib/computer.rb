class Computer
  def pick_word
    words = []
    File.open('google-10000-english-no-swears.txt', 'r') do |file|
      file.each_line do |line|
        words << line.chomp if line.length >= 5 && line.length <= 12
      end
    end
    words.sample
  end
end
