
Gem::Specification.new do |s|
  s.name        = 'assorted-candy'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Yury Batenko'
  s.email       = 'jutbat@gmail.com'
  s.summary     = 'All Sorts Of Staff Assorted Candy'
  s.description = 'Collection of handy Ruby extensions borrowed from around the Ruby world'

  s.files         = `git ls-files`.split($/)
  s.require_path  = '.'
  s.extra_rdoc_files = [
    'MIT-LICENSE.txt',
    'README.md'
  ]

end
