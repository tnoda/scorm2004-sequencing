# scorm2004-sequencing

**Note:** This project is a work in progress. This README file is being prepared for the future development.

The scorm2004-sequencing gem provides a sequencing engine for SCORM 2004 LMSs based on Ruby 2.0.

+ https://rubygems.org/gems/scorm2004-sequencing
+ https://github.com/tnoda/scorm2004-sequencing


## Installation

Add this line to your application's Gemfile:

    gem 'scorm2004-sequencing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scorm2004-sequencing


## Usage

    require 'scorm2004-manifest'
    require 'scorm2004-sequencing'

    m = Scorm2004::Manifest.new(open('imsmanifest.xml'))
    at = Scorm2004::Sequencing::ActivityTree.new(manifest: m, identifier: 'CM-01')
    proc = Scorm2004::Sequencing::Process.new(activity_tree: at, navigation_request: :start)
    learner_state = {}
    catch(:sequencing_exception) do
      updated_learner_state = proc.call(learner_state)
    end

    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
