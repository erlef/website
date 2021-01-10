defmodule ErlefWeb.WorkingGroupView do
  use ErlefWeb, :view

  def calendar(ics_url) do
    ~E"""
    <div class="modal fade" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body ml-1">
            <div class="row">
              <div class="col-3">
                <strong>Title</strong>
              </div>

              <div class="col">
                <span class="title"></span>
              </div>
            </div>

            <div class="row">
              <div class="col-3">
                <strong>Starts</strong>
              </div>
              <div class="col">
                <span class="starts-at"></span>
              </div>
            </div>
            <div class="row">
              <div class="col-3">
                <strong>Ends</strong>
              </div>
              <div class="col">
                <span class="ends-at"></span>
              </div>
            </div>
            <div class="row">
              <div class="col-3">
                <strong class="description-label">Description</strong>
              </div>
              <div class="col">
                <span class="description"></span>
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div><!-- /.modal-body -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->


    <div class="container">
        <div id="calendar"
             data-calendar-header="true"
             data-calendar-ics-url="<%= ics_url %>"
             class="mt-5">
        </div>
    </div>
    """
  end
end
