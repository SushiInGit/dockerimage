# Update Medusa-Files
FROM ghcr.io/sushiingit/medusa.js:image
ENV TOKEN="$DISCORD_TOKEN"
ENV GUILD="$DISCORD_GUILD"
ENV CLIENT_ID="$DISCORD_CLIENTID"
ARG BUILD_DATE

WORKDIR /app
ENV PATH="/opt/venv/bin:$PATH"
COPY /src/requirements.txt .
RUN pip install -r requirements.txt
COPY /src .

CMD [ "python3", "./bot.py" ]
