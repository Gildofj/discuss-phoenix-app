import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive("ok", ({ comments }) => {
      renderComments(comments);
    })
    .receive("error", resp => { console.log("Unable to join", resp) });

  channel.on(`comments:${topicId}:new`, ({ comment }) => renderComment(comment));

  document.getElementById("add-comment").addEventListener("click", (e) => {
    e.preventDefault();

    const content = document.getElementById("comment").value;
    document.getElementById("comment").value = null;

    channel.push("comment:add", { content: content });
  });
};

function renderComments(comments) {
  const renderedComments = comments.map((comment) => commentTemplate(comment));

  document.getElementById("comments").innerHTML = renderedComments.join("");
};

function renderComment(comment) {
  document.getElementById("comments").innerHTML += commentTemplate(comment);
};

function commentTemplate({ content, inserted_at }) {
  return `
      <li class="w-full relative flex justify-between border border-purple-500 p-3 rounded bg-purple-100">
        ${content}
        <div class="absolute text-xs bottom-1 right-1">
          ${inserted_at.split("T")[0]}
        </div>
      </li>
    `;
};

window.createSocket = createSocket
