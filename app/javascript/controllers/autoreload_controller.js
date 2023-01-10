import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // reload turboframes every 60 seconds
    document.querySelectorAll('turbo-frame').forEach((turboframe) => {
      setInterval(() => {
        let src = turboframe.src
        turboframe.src = null
        turboframe.src = src
      }, 60000)
    })
  }
}
