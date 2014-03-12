require 'rspec'
require 'webmock'
require 'vcr'

RSpec.configure do |c|
   # Use color in STDOUT
  c.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  c.tty = true

  # Use the specified formatter
  c.formatter = :documentation # :progress, :html, :textmate
end

VCR.configure do |c|
  c.cassette_library_dir = "fixtures/vcr_cassettes"
  c.hook_into :webmock
end
