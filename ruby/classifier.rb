require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

bayes = OmniCat::Classifiers::Bayes.new
bayes.add_category('name')
bayes.add_category('artist')

File.readlines('../data/names.txt').each do |name|
  bayes.train('name', name)
end

File.readlines('../data/artists.txt').each do |artist|
  bayes.train('artist', artist)
end

things = ["The Nut Job", "A Callaghan", "Emily Callaghan", "Callaghan's Crooners", "Albany/Buffalo", "Abhay Shukla"]

results = bayes.classify_batch(things)
puts results.collect(&:to_hash)

bayes_hash = bayes.to_hash

File.open('../data/bayes.dat', "w") { |to_file|
  Marshal.dump(bayes_hash, to_file)
}

# new_hash = File.open('../data/bayes.dat', "r") { |from_file|
#   Marshal.load(from_file)
# }

# another_bayes_obj = OmniCat::Classifiers::Bayes.new(new_hash)
# puts another_bayes_obj.classify('George W Bush').to_hash
