class MigrateExistingScriptsToSiteConfigBeforeBodyTagEnd < ActiveRecord::Migration
  def up
    if Rails.env.staging? || Rails.env.production?
      script = SiteConfig.sanitize("<script type=\"text/javascript\"> google_ad_client = \"ca-pub-8370998771772384\"; google_ad_slot = \"5184648881\"; google_ad_width = 728; google_ad_height = 90; </script> <script type=\"text/javascript\" src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\">; </script>\r\n\r\n<!-- ASM script begin --> <div id=\"cX-root\" style=\"display:none\"></div> <script type=\"text/javascript\"> var cX = cX || {}; cX.callQueue = cX.callQueue || []; cX.callQueue.push(['setAccountId', '9222259185757035874']); cX.callQueue.push(['setSiteId', '9222276788448967873']); cX.callQueue.push(['sendPageViewEvent']); </script> <script type=\"text/javascript\"> (function() { try { var scriptEl = document.createElement('script'); scriptEl.type = 'text/javascript'; scriptEl.async = 'async'; scriptEl.src = ('https:' == document.location.protocol) ? 'https://scdn.cxense.com/cx.js' : 'http://cdn.cxense.com/cx.js'; var targetEl = document.getElementsByTagName('script')[0]; targetEl.parentNode.insertBefore(scriptEl, targetEl); } catch (e) {};} ()); </script> <!-- ASM script end -->\r\n\r\n<script type=\"text/javascript\"> var _ohtConfig = { debug : true, v : 0.1, mscp : ('https:' == document.location.protocol ? 'https://' : 'http://') + 'owsassets.onehourtranslation.com/build/0.1', services:{ mlft : { formid : 52271, src : 'http://www.onehourtranslation.com' } } }; (function() { var oscr = document.createElement('script'); oscr.type = 'text/javascript'; oscr.async = true; oscr.src = _ohtConfig.mscp+'/all.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(oscr, s); })(); </script> <a href=\"http://www.onehourtranslation.com/\" class=\"oht_ref\">Translation Services</a>")
      execute "UPDATE site_configs SET before_body_tag_end = #{script}"
    end
  end

  def down
  end
end
