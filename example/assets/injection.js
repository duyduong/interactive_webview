const SendActions = {
  ready: "ready",
  loadNews: "loadNews"
};

class NativeCaller {
  constructor() {
    this.communicator =
      window.ReactNativeWebView ||
      window.native ||
      webkit.messageHandlers.native;

    // queues for downloading html
    this.queues = {};
  }

  postMessage(action, data) {
    const jsonString = JSON.stringify({
      action: action,
      data: data || {}
    });

    this.communicator.postMessage(jsonString);
  }
}

const nativeCaller = new NativeCaller(),
  baseUrl = "https://www.gosugamers.net/";

// Inject jQuery if not
function injectjQuery() {
  return new Promise((resolve, reject) => {
    const script = document.createElement("script");
    script.id = "my_injection";
    script.onload = () => resolve();
    script.onerror = () => reject();
    script.src = "https://code.jquery.com/jquery-3.3.1.min.js";

    document.head.appendChild(script);
  });
}

async function getReady() {
  await injectjQuery();

  // Get the tabs data
  const tabs = $(".tabs li")
    .map((i, el) => {
      const href = $(el)
          .find("a")
          .attr("href"),
        link = `${baseUrl}${href}`;
      return {
        name: $(el)
          .text()
          .trim(),
        link: link
      };
    })
    .toArray()
    .filter(tab => !tab.name.toLowerCase().includes("guides"));

  // Notify that we are ready to rock
  nativeCaller.postMessage(SendActions.ready, tabs);
}

function loadNews(link) {
  $.get(link).done(body => {
    const news = $(`<div>${body}</div>`)
      .find(".news-post")
      .map((i, el) => {
        el = $(el);
        return {
          thumbnail: el.find("a.post-thumbnail img").attr("src"),
          title: el
            .find(".post-content a h4")
            .text()
            .trim(),
          desc: el
            .find(".post-excerpt")
            .text()
            .trim()
        };
      })
      .toArray();
    nativeCaller.postMessage(SendActions.loadNews, news);
  });
}
