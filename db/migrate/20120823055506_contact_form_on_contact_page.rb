class ContactFormOnContactPage < ActiveRecord::Migration
  def up
    contact = Cmspage.find_by_page_url('contact')
    
    if contact.present?
      contact.description = '<div class="span16 offset1">
<div class="span4">
<h3>Contact Us:</h3>
<div>
<form action="/sendcontact" method="post" name="contact" id="contact_form">
<table>
<tr>
  <td><label for="contact_name">Name*</label></td>
  <td><input type="text" name="contact[name]" id="contact_name"></td>
</tr>
<tr>
  <td><label for="contact_email">Email*</label></td>
  <td><input type="text" name="contact[email]" id="contact_email"></td>
</tr>
<tr>
  <td><label for="contact_subject">Subject*</label></td>
  <td><input type="text" name="contact[subject]" id="contact_subject"></td>
</tr>
<tr>
  <td><label for="contact_query">Message*</label></td>
  <td><textarea rows=5 columns=4 id="contact_query" name=contact[query]> </textarea></td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>
      <input type="submit" id="contact_submit" value="Submit"/>
  </td>
</tr>
</table>
</form>
</div>
<h3>Contact Information:</h3>
<p>SquareStays</p>
<p>HeyPal Pte Ltd</p>
<p>71 Ayer Rajah Crescent 07-05</p>
<p>Singapore 139951</p>
<p>support@squarestays.com</p>
</div>
<div class="span"><iframe src="http://maps.google.com/maps?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=71+Ayer+Rajah+Crescent,+Singapore&amp;aq=0&amp;oq=71+Ayer+Rajah+Crescent&amp;sll=1.296767,103.786752&amp;sspn=0.006822,0.009602&amp;vpsrc=6&amp;g=71+Ayer+Rajah+Crescent,+Singapore+139951&amp;ie=UTF8&amp;hq=&amp;hnear=71+Ayer+Rajah+Crescent,+Singapore+139951&amp;ll=1.29677,103.786747&amp;spn=0.013644,0.019205&amp;t=m&amp;z=14&amp;output=embed" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" width="425" height="350"></iframe><br /><small><a style="color: #0000ff; text-align: left;" href="http://maps.google.com/maps?f=q&amp;source=embed&amp;hl=en&amp;geocode=&amp;q=71+Ayer+Rajah+Crescent,+Singapore&amp;aq=0&amp;oq=71+Ayer+Rajah+Crescent&amp;sll=1.296767,103.786752&amp;sspn=0.006822,0.009602&amp;vpsrc=6&amp;g=71+Ayer+Rajah+Crescent,+Singapore+139951&amp;ie=UTF8&amp;hq=&amp;hnear=71+Ayer+Rajah+Crescent,+Singapore+139951&amp;ll=1.29677,103.786747&amp;spn=0.013644,0.019205&amp;t=m&amp;z=14">View Larger Map</a></small></div>
</div>';
      contact.save
    end
  end

  def down
  end
end
