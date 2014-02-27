class AboutScreen < Formotion::FormController
  include BW::KVO

  def init
    @form ||= Formotion::Form.new({
      sections: [{
        title: "Settings:",
        rows: [{
          title: "Use Metric Units",
          subtitle: "You can also tap altitudes to change this.",
          type: :switch,
          value: App::Persistence['metric']
        }, {
          title: "Dynamic Wind Indicators",
          subtitle: "Updates direction based on compass.",
          type: :switch,
          value: App::Persistence['compass']
        }]
      },{
        title: "Share With Your friends:",
        rows: [{
          title: "Share the app",
          subtitle: "Text, Email, Tweet, or Facebook!",
          type: :share,
          image: "share",
          value: {
            items: "I'm using the #{App.name} app to send cool text art. Check it out! http://www.mohawkapps.com/app/textables/",
            excluded: excluded_services
          }
        },{
          title: "Rate #{App.name} on iTunes",
          type: :rate_itunes,
          image: "itunes"
        }]
      }, {
        title: "#{App.name} is open source:",
        rows: [{
          title: "View on GitHub",
          type: :github_link,
          image: "github",
          warn: true,
          value: "https://github.com/MohawkApps/aloft"
        }, {
          title: "Found a bug?",
          subtitle: "Log it here.",
          type: :issue_link,
          image: "issue",
          warn: true,
          value: "https://github.com/MohawkApps/aloft/issues/"
        }, {
          title: "Email me suggestions!",
          subtitle: "I'd love to hear from you",
          type: :email_me,
          image: "email",
          value: {
            to: "mark@mohawkapps.com",
            subject: "#{App.name} App Feedback"
          }
        }]
      }, {
        title: "About #{App.name}:",
        rows: [{
          title: "Version",
          type: :static,
          placeholder: App.info_plist['CFBundleShortVersionString'],
          selection_style: :none
        }, {
          title: "Copyright",
          type: :static,
          font: { name: 'HelveticaNeue', size: 14 },
          placeholder: "© 2014, Mohawk Apps, LLC",
          selection_style: :none
        }, {
          title: "Visit MohawkApps.com",
          type: :web_link,
          warn: true,
          value: "http://www.mohawkapps.com"
        }, {
          title: "Made with ♥ in North Carolina",
          type: :static,
          enabled: false,
          selection_style: :none,
          text_alignment: NSTextAlignmentCenter
        },{
          type: :static_image,
          value: "nc",
          enabled: false,
          selection_style: :none
        }]
      }]
    })
    super.initWithForm(@form)
  end

  def viewDidLoad
    super
    self.title = "Settings"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop, target:self, action:"close")
    observe_switches
  end

  def close
    dismissModalViewControllerAnimated(true)
  end

  def excluded_services
    [
      UIActivityTypeAddToReadingList,
      UIActivityTypeAirDrop,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypePrint
    ]
  end

  def observe_switcnes
    metric = @form.sections[0].rows[0]
    compass = @form.sections[0].rows[1]

    observe(metric, "value") do |old_value, new_value|
      App::Persistence['metric'] = new_value
    end
    observe(compass, "value") do |old_value, new_value|
      App::Persistence['compass'] = new_value
    end
  end

end
