import json
import pandas as pd

DEFAULT_SYSTEM_PROMPT = 'You are customer support bot. You should help to user to answer on his question.'


def get_example(question, answer):
    return {
        "messages": [
            {"role": "system", "content": DEFAULT_SYSTEM_PROMPT},
            {"role": "user", "content": question},
            {"role": "assistant", "content": answer},
        ]
    }


if __name__ == "__main__":
    df = pd.read_csv("data.csv")
    with open("train.jsonl", "w") as f:
        for i, row in list(df.iterrows()):
            question = row["question"]
            answer = row["answer"]
            example = get_example(question, answer)
            example_str = json.dumps(example)
            f.write(example_str + "\n")

    print("DONE")
