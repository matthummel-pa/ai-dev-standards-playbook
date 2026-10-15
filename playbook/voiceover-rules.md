# Voice-over rules (recording your own narration)

Target: soft and warm, never flat and never rushed. Record in the [Voiceover Booth](https://matthummel-pa.github.io/ai-dev-standards-playbook/booth/); it coaches these rules live.

## Before you record
- Warm up: hum low to high for 20 s, a few tongue twisters, five belly breaths, then read the whole script aloud once.
- Water. No coffee, milk or soda in the last 30 minutes.
- Mic one side-turned fist from your mouth, slightly off-center, pop filter on. Headphones on. Phone silent, fans off.
- Measure room tone in the booth. Under −55 dB is good; over −45 dB, move or get closer.
- Mark the script: underline operative words, `/` short pause, `//` breath. The booth does a first pass; override by ear.

## While you record
- One listener, one intention per line. Talk to one person.
- Pace 140–160 wpm. Short punchy lines go *slower* than long ones, then a beat.
- Emphasis comes from pitch and time, not volume. Lift one operative word per sentence, stretch its vowel a little, let the ending settle. Don't fall the same way on every sentence; lists get a different pitch per item.
- Breathe in, let a little out, then speak. Keep the mouth open between phrases.
- Stumble: stop, breathe, retake from the top of the line. Don't push through.
- Don't cut the last line short; it's the one that lands.
- Same distance every take. Level drift between takes is the first thing a listener feels.

## Booth thresholds (soft & warm preset)
Pace 148 ±20 wpm · melody ≥ 2.0 semitones · no internal pause over 0.35 s · level above −34 dB, no clipping. A take outside these gets "Retake suggested"; keep it anyway if it sounds right.

## After: the post chain (`ingest.py`)
Highpass 80 Hz → adaptive noise reduction → −3.5 dB at 300 Hz → +4 dB at 2.8 kHz → −4 dB shelf above 7 kHz → de-esser → light gate → 3:1 compression → per-line RMS match → two-pass loudnorm −16 LUFS / LRA 7 / TP −2 → music at 0.26 ducked 6:1 → mix −14 LUFS.

Sources: [Such A Voice: breaking monotonous reads](https://www.suchavoice.com/?p=35295) · [SEJ: Voicing Your Script](https://em.sej.org/sites/default/files/VoicingYourScript101912.pdf) · [Voicebros explainer VO guide](https://voicebros.com/en/blog/explainer-video-voice-over-guide)
