defmodule ErlefWeb.HTML do
  @moduledoc """
  ErlefWeb.HTML - HTML helpers for ErlefWeb
  """
  import Phoenix.HTML.Tag

  def to_date_string(date_time) do
    Calendar.strftime(date_time, "%B, %d, %Y, %H:%M:%S UTC")
  end

  def right_svg_hero(f_opts, opts) when is_list(f_opts) do
    right_svg_hero(f_opts ++ opts)
  end

  def right_svg_hero(text, opts) do
    right_svg_hero(text, [{:do, text}] ++ opts)
  end

  def right_svg_hero(opts) do
    class = "clip-svg clip-svg-hero right-bleed bg-dark"
    div_tag([{:class, class}] ++ opts)
  end

  def left_svg_hero(f_opts, opts) when is_list(f_opts) do
    left_svg_hero(f_opts ++ opts)
  end

  def left_svg_hero(text, opts) do
    left_svg_hero([{:do, text}] ++ opts)
  end

  def left_svg_hero(opts) do
    class = "clip-svg clip-svg-hero left-bleed bg-dark"
    div_tag([{:class, class}] ++ opts)
  end

  def div_tag(text, opts) do
    content_tag(:div, text, opts)
  end

  def div_tag(opts) when is_list(opts) do
    error = "div_tag/2 requires a text as first argument or contents in the :do block"
    {contents, opts} = pop_required_option!(opts, :do, error)
    div_tag(contents, opts)
  end

  # TODO: This doesn't belong here
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



               <input class="col-lg-auto btn btn-primary ml-2" type="submit" value="Subscribe">

           </div>
         </div>
     </form>
    """
  end

  defp pop_required_option!(opts, key, error_message) do
    {value, opts} = Keyword.pop(opts, key)

    unless value do
      raise ArgumentError, error_message
    end

    {value, opts}
  end
end
