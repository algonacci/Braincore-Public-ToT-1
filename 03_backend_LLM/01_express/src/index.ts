import cors from 'cors'
import express from 'express'

const app = express()
app.use(express.json())
app.use(cors())

app.post('/', async (req, res) => {
  const { content } = req.body
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'Bearer ',
    },
    method: 'POST',
    body: JSON.stringify({
      model: 'gpt-3.5-turbo',
      messages: [
        {
          role: 'system',
          content: 'You are a helpful assistant.'
        },
        {
          role: 'user',
          content: content
        }
      ],
      stream: true
    })
  })

  if (!response.body) return
  const reader = response.body.getReader()
  const decoder = new TextDecoder()

  let isFinished = false
  const bags: string[] = []
  while (!isFinished) {
    const { value, done } = await reader.read()
    isFinished = done

    const decodedValue = decoder.decode(value)
    if (!decodedValue) break

    for (const chunk of decodedValue.split('\n\n')) {
      if (chunk.trim() === 'data: [DONE]') continue

      bags.push(chunk)
      try {
        const json = JSON.parse(bags.join('').split('data: ').at(-1) || '{}')
        const text = json.choices?.[0]?.delta?.content
        if (text) {
          res.write(text)
        }
      } catch (error) {
        // ignore
      }
    }
  }

  res.end()

})

app.listen(4000, () => {
  console.log('Server listening on port 4000')
})
