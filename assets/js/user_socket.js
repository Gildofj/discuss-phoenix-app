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

function commentTemplate({ content, user, inserted_at }) {
  const email = user?.email || "Anonymous";

  return `
      <li class="w-full relative flex justify-between border border-purple-500 p-3 pb-6 rounded bg-purple-100">
        ${content}
        <div class="absolute flex items-center justify-between w-full text-xs right-1 left-1 bottom-1">
          <span class="text-purple-700 font-semibold">
            ${email}
          </span>
          <span class="pr-2">
            ${inserted_at.split("T")[0]} at ${inserted_at.split("T")[1].split(":").map((v, i) => i != 2 ? v : undefined).join(":").substring(0, 5)}
          </span>
        </div>
      </li>
    `;
};

window.createSocket = createSocket
