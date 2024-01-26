const generateButton = document.getElementById("generateButton");
const promptInput = document.getElementById("prompt");
const generatedText = document.getElementById("generatedText");

generateButton.addEventListener("click", async () => {
  const prompt = promptInput.value;
  if (prompt.trim() === "") {
    alert("Please enter a prompt.");
    return;
  }

  const apiKey = "sk-";

  // Make a POST request to the OpenAI API
  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      messages: [
        { role: "system", content: "You are a helpful assistant." },
        { role: "user", content: prompt },
      ],
      max_tokens: 4000,
      model: "gpt-3.5-turbo",
      stream: true,
    }),
  });

  if (!response.ok) {
    console.error("Error:", response.statusText);
    generatedText.textContent = "Error occurred while generating text.";
    return;
  }

  const reader = response.body.getReader();
  const decoder = new TextDecoder();
  let isFinished = false;
  let generatedTextContent = "";

  while (!isFinished) {
    const { done, value } = await reader.read();
    if (done) {
      isFinished = true;
      break;
    }

    const chunkText = decoder.decode(value);
    const lines = chunkText.split("\n");

    for (const line of lines) {
      const trimmedLine = line.trim();

      // Check if the line starts with 'data:' and remove it
      const jsonText = trimmedLine.startsWith("data: ") ? trimmedLine.substring(6) : trimmedLine;

      // Check for the control message indicating end of data
      if (jsonText === "[DONE]") {
        isFinished = true;
        break;
      }

      try {
        if (jsonText) {
          const json_data = JSON.parse(jsonText);
          const text = json_data.choices[0]?.delta.content || "";
          if (text) {
            generatedTextContent += text;
            generatedText.textContent = generatedTextContent;
          }
        }
      } catch (error) {
        console.error("JSON parsing error:", error);
      }
    }

    await new Promise((resolve) => setTimeout(resolve, 50));
  }
});
