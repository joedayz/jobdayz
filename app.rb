require "cuba"
require "cuba/safe"
require "delegate"
require "mote"
require "mote/render"
require "rack/protection"
require "malone"
require "scrivener"
require "ost"
require "ohm"


APP_SECRET = ENV.fetch("APP_SECRET")
GITHUB_CLIENT_ID = ENV.fetch("GITHUB_CLIENT_ID")
GITHUB_CLIENT_SECRET = ENV.fetch("GITHUB_CLIENT_SECRET")
GITHUB_OAUTH_AUTHORIZE = ENV.fetch("GITHUB_OAUTH_AUTHORIZE")
GITHUB_OAUTH_ACCESS_TOKEN = ENV.fetch("GITHUB_OAUTH_ACCESS_TOKEN")
GITHUB_FETCH_USER = ENV.fetch("GITHUB_FETCH_USER")
MALONE_URL = ENV.fetch("MALONE_URL")
REDIS_URL = ENV.fetch("OPENREDIS_URL")
RESET_URL = ENV.fetch("RESET_URL")
STRIPE_PUBLISHABLE_KEY = ENV.fetch("STRIPE_SECRET_KEY")

Cuba.plugin(Mote::Render)

Ohm.redis = Redic.new(REDIS_URL)
Ost.redis = Redic.new(REDIS_URL)
Malone.connect(url: MALONE_URL, tls: false, domain: "joedayz.pe")

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }
Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./filters/**/*.rb"].each { |rb| require rb }
Dir["./lib/**/*.rb"].each     { |rb| require rb }

Cuba.use Rack::Session::Cookie,
  key: "jobdayz",
  secret: "_secret_"

Cuba.use Rack::Protection, except: :http_origin
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  urls: %w[/js /css /img],
  root: File.expand_path("./public", __dir__)



Cuba.define do
  
  
  on root do
    res.write("Iniciando...")
  end

  on "about" do
    render("about", title: "About",
      background_img: true)
  end

  on "pricing" do
    render("pricing", title: "Pricing", 
      plan_id: "small", background_img: true)
  end

  on "help" do
    render("help", title: "Help")
  end

  on "terms" do
    render("terms", title: "Terms and Conditions")
  end

  on "privacy" do
    render("privacy", title: "Privacy Policy")
  end
  
  on "contact" do
    run Contacts
  end  

end
