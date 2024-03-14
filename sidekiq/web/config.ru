# frozen_string_literal: true

require 'delegate'
require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'securerandom'

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

# https://github.com/mperham/sidekiq/issues/4850
# https://github.com/mperham/sidekiq/issues/5153
use Rack::Session::Cookie, secret: SecureRandom.hex(32), same_site: true, max_age: 86_400

map '/' do
  if ENV['SIDEKIQ_AUTH_STATUS'] == 'active'
    use Rack::Auth::Basic, 'Protected Area' do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      Rack::Utils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_AUTH_USERNAME', nil))
      ) &
        Rack::Utils.secure_compare(
          ::Digest::SHA256.hexdigest(password),
          ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_AUTH_PASSWORD', nil))
        )
    end
  end

  run Sidekiq::Web
end

map '/alb_health' do
  run ->(_env) { [200, { 'Content-Type' => 'text/html' }, []] }
end
