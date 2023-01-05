import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setInterval(() => window.location.reload(), 60000)
  }
}
