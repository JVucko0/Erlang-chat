import React, { useEffect, useState, useRef } from "react";

const Page: React.FC = () => {
  const [messages, setMessages] = useState<string[]>([]);
  const [input, setInput] = useState<string>("");
  const ws = useRef<WebSocket | null>(null);

  useEffect(() => {
    const socket = new WebSocket("ws://localhost:8080/ws");
    ws.current = socket;

    socket.onopen = () => {
      console.log("🔌 WebSocket povezan");
    };

    socket.onmessage = (event: MessageEvent) => {
      setMessages((prev) => [...prev, event.data]);
    };

    socket.onclose = () => {
      console.log("❌ WebSocket zatvoren");
    };

    socket.onerror = (error) => {
      console.error("⚠️ WebSocket greška:", error);
    };

    return () => {
      socket.close();
    };
  }, []);

  const sendMessage = () => {
    if (ws.current && input.trim() !== "") {
      ws.current.send(input);
      setInput("");
    }
  };

  return (
    <div style={{ maxWidth: "600px", margin: "0 auto" }}>
      <h2>🗨️ Group Chat</h2>
      <div style={{
        border: "1px solid #ccc",
        padding: "10px",
        minHeight: "200px",
        maxHeight: "300px",
        overflowY: "auto",
        background: "#f9f9f9"
      }}>
        {messages.map((msg, idx) => (
          <div key={idx} style={{ marginBottom: "8px" }}>{msg}</div>
        ))}
      </div>
      <div style={{ marginTop: "10px" }}>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Unesi poruku..."
          style={{ width: "80%", padding: "5px" }}
        />
        <button onClick={sendMessage} style={{ marginLeft: "10px", padding: "5px 10px" }}>
          Pošalji
        </button>
      </div>
    </div>
  );
};

export default Page;
