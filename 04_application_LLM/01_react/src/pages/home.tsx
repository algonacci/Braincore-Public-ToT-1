import { useState, useRef } from "react";

type Messages = { role: "system" | "user" | "assistant"; content: string }[];

export default function Home() {
  const [messages, setMessages] = useState<Messages>([
    {
      role: "system",
      content: "You are a helpful assistant.",
    },
  ]);
  const formRef = useRef<HTMLFormElement | null>(null);
  return (
    <div>
      <div className="container mx-auto px-12">
        <div className="prose">
          {messages?.map((message, index) => (
            <p key={index}>
              <em>{message.role}</em>: {message.content}
            </p>
          ))}
        </div>
        <form
          ref={formRef}
          onSubmit={async (e) => {
            e.preventDefault();
            const formData = new FormData(e.currentTarget);
            const data = Object.fromEntries(formData.entries());
            const payloadMessages = [
              ...messages,
              {
                role: "user",
                ...(data as { content: string }),
              },
              {
                role: "assistant",
                content: "",
              },
            ];
            setMessages(payloadMessages as Messages);
            formRef.current?.reset();
            const response = await fetch("http://localhost:5000", {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Authorization: "Bearer secret",
              },
              body: JSON.stringify({
                content: data.content,
              }),
            });

            if (!response.body) return;
            const reader = response.body.getReader();
            const decoder = new TextDecoder();
            let isFinished = false;
            while (!isFinished) {
              const { value, done } = await reader.read();
              isFinished = done;

              const decodedValue = decoder.decode(value);
              if (!decodedValue) break;

              setMessages((messages) => [
                ...messages.slice(0, messages.length - 1),
                {
                  role: "assistant",
                  content: `${messages[messages.length - 1].content}${decodedValue}`,
                },
              ]);
            }
          }}
        >
          <div className="form-control">
            <label>
              <span className="label-text">Content</span>
            </label>
            <textarea name="content" rows={3} className="textarea textarea-bordered" required></textarea>
          </div>
          <div className="form-control mt-4">
            <button type="submit" className="btn btn-primary">
              Submit
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
