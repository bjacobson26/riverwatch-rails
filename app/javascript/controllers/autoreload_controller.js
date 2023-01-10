import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // reload turboframes every 60 seconds
    document.querySelectorAll('turbo-frame').forEach((turboframe) => {
      let interval = 60000
      if(turboframe.id == "highway") {
        interval = 65000
      }

      let src = turboframe.src

      setInterval(() => {
        turboframe.src = null
        turboframe.src = src
      }, interval)
    })
  }
}
