defmodule ErlefWeb.PageView do
  use ErlefWeb, :view

  def subscribe_form do
    """
     <form action="https://erlef.us20.list-manage.com/subscribe/post?u=8d8ff4d9284d463c374e574bb&amp;id=8cad7357f8" 
           method="post" id="mc-embedded-subscribe-form" 
           name="mc-embedded-subscribe-form" 
           class="validate mc4wp-form mc4wp-form-116" 
           target="_blank" novalidate> 
         <div>
           <div style="position: absolute; left: -5000px;" aria-hidden="true">
             <input type="text" name="b_8d8ff4d9284d463c374e574bb_8cad7357f8" tabindex="-1" value="">
           </div>

           <div class="form-row subscribe">
             
               <input class="col-lg-6 form-control" type="email" name="EMAIL" placeholder="Your e-mail address" required="">
            

             
               <input class="col-lg-auto btn btn-primary ml-2" type="submit" value="Subscribe to our Newsletter">
            
           </div>
         </div>    
     </form>
    """
  end
end
