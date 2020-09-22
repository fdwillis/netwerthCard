class HomeController < ApplicationController

	def profile
		if current_user&.stripeSourceVerified && current_user&.stripeUserID
			callCurl = current_user.showStripeUserAPI

			if callCurl['success']
				@sources = callCurl['sources']
			else
				current_user.createUserSessionAPI(current_user.encrypted_password)
				redirect_to services_path
			end
		end
	end

  def service_worker
  	
  end

  def manifest
  	manifest = {
		"version" => "3.0",
		"comment" => "---Above version must be the same as data-pwa-version",
		"comment" => "---data-pwa-version can be found in / in the manifest tag",
		"comment" => "---if versions are not the same it will cause an update loop",
		"lang"  => "en",
		"name"  => "Messy Lawns",
		"scope"  => "/",
		"display"  => "fullscreen",
		"start_url"  => "/",
		"short_name"  => "Messy Lawns",
		"description"  => "",
		"orientation"  => "portrait",
		"background_color" => "#000000",
		"theme_color" => "#000000",
		"generated"  => "true",
		  "icons" => [
		    {
		      "src" => "app/icons/icon-72x72.png",
		      "sizes" => "72x72",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-96x96.png",
		      "sizes" => "96x96",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-128x128.png",
		      "sizes" => "128x128",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-144x144.png",
		      "sizes" => "144x144",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-152x152.png",
		      "sizes" => "152x152",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-192x192.png",
		      "sizes" => "192x192",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-384x384.png",
		      "sizes" => "384x384",
		      "type" => "image/png"
		    },
		    {
		      "src" => "app/icons/icon-512x512.png",
		      "sizes" => "512x512",
		      "type" => "image/png"
		    }
		  ]
		}

		return manifest
  end
end