defmodule ErlefWeb.PageView do
  use ErlefWeb, :view

  def subscribe_form do
    """
     <form action="https://erlef.us20.list-manage.com/subscribe/post?u=8d8ff4d9284d463c374e574bb&amp;id=8cad7357f8" 
           method="post" id="mc-embedded-subscribe-form" 
           name="mc-embedded-subscribe-form" 
           class="validate mc4wp-form mc4wp-form-116" 
           target="_blank" novalidate>    
         <div class="mc-form-fields">
           <div style="position: absolute; left: -5000px;" aria-hidden="true">
             <input type="text" name="b_8d8ff4d9284d463c374e574bb_8cad7357f8" tabindex="-1" value="">
           </div>

           <div class="subscribe">
             <p class="col-xs-4 col-md-4 col-lg-4" style="padding-left: 0">
               <input type="email" name="EMAIL" placeholder="Your e-mail address" required="">
             </p>

             <p class="col-xs-4 col-md-4 col-lg-4 mailform" style="padding-left: 0">
               <input style="border-color: #BBBBBB; width: 100%;" type="submit" value="Subscribe">
             </p>
           </div>
         </div>    
     </form>
    """
  end
end
