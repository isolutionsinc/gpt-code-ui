import "./Chat.css";

import VoiceChatIcon from "@mui/icons-material/VoiceChat";
import PersonIcon from "@mui/icons-material/Person";
import { MessageDict } from "../App";

import SyntaxHighlighter from "react-syntax-highlighter";
import { RefObject } from "react";

function Message(props: {
  text: string;
  role: string;
  type: string;
  showLoader?: boolean;
}) {
  let { text, role } = props;

  return (
    <div className={"message " + (role == "system" ? "system" : "user")}>
      <div className="avatar-holder">
        <div className="">
          {role == "system" ? <img src="./assets/isol_logo_ai_transparent.png" alt="Logo" width="48" height="48" style={{ marginRight: '10px' }} /> : <PersonIcon />}
        </div>
      </div>
      <div className="message-body">
        {props.type == "code" && (
          <div>
            I generated the following code:
            <SyntaxHighlighter wrapLongLines={true} language="python">
              {text}
            </SyntaxHighlighter>
          </div>
        )}

        {(props.type == "message" || props.type == "message_raw") &&
          (props.showLoader ? (
            <div>
              {text} {props.showLoader ? <div className="loader"></div> : null}
            </div>
          ) : (
            <div className="cell-output" dangerouslySetInnerHTML={{ __html: text }}></div>
          ))}
        
        {props.type == "image/png" &&
          <div className="cell-output-image" dangerouslySetInnerHTML={{ __html: `<img src='data:image/png;base64,${text}' />` }}></div>
        }
        {props.type == "image/jpeg" &&
          <div className="cell-output-image" dangerouslySetInnerHTML={{ __html: `<img src='data:image/jpeg;base64,${text}' />` }}></div>
        }
        </div>
    </div>
  );
}

export enum WaitingStates {
  GeneratingCode = "Generating code",
  RunningCode = "Running code",
  UploadingFile = "Uploading file",
  Idle = "Idle",
}

export default function Chat(props: {
  waitingForSystem: WaitingStates;
  chatScrollRef: RefObject<HTMLDivElement>;
  messages: Array<MessageDict>;
}) {
  return (
    <>
      <div className="chat-messages" ref={props.chatScrollRef}>
        {props.messages.map((message, index) => {
          return (
            <Message
              key={index}
              text={message.text}
              role={message.role}
              type={message.type}
            />
          );
        })}
        {props.waitingForSystem != WaitingStates.Idle ? (
          <Message
            text={props.waitingForSystem}
            role="system"
            type="message"
            showLoader={true}
          />
        ) : null}
      </div>
    </>
  );
}
