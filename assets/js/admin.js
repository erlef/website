import css from "../css/admin.scss";
import "phoenix_html";
import "jquery";
import "bootstrap";
import "admin-lte";

// $('[data-bs-toggle="tooltip"]').tooltip();

export default class App {
  constructor() {
    $(document).ready(function () {
      $("[data-bs-toggle='popover']").popover({ container: "body", html: true, animation: false });
    });
  }
}

window.app = new App();