# MultiProcessorsGenstage

Experimentation on the utility of multi processors Broadway pipelines.

I have a processing pipeline that looks like this:

- analysis: find interesting moments in a video
- encoding: cut clips around these interesting moments and reencode them in 720p

The second phase is CPU intensive with ffmpeg using all cores, while the first
is more IO bound.

My first implementation used [Broadway](https://elixir-broadway.org/) and had
issues when too much ffmpeg processes were running concurrently. So I thought
it would be nice to have a stage with a lot of processes for the first phase,
and a second stage with fewer processes for the second phase, and started
rewriting the project with GenStage. Seeing this was no small feat, I did some
research and found [this
issue](https://github.com/dashbitco/broadway/issues/39#issuecomment-925588101),
where I explained my problem.

José Valim kindly suggested to use a pool to constrain ffmpeg resources. I
couldn't tell from intuition what would the performance characteristics of the
pool implementation be, so I did this little experiment.

## Running the benchmark

The `main` branch contains a 2 stages `GenStage` implementation, simulating
what a multi processors Broadway pipeline would look like.

The `pool` branch has a single stage and limit the second phases processes with a pool.

You can run the experiment with:
```
mix deps.get
mix run --no-halt
```

## Results

2 stages implementation:
```
13:56:28.047 [info]  Telemetry report 2021-09-24 11:56:28.046905Z:
  Event [:event, :finished]
    Measurement "duration"
      Summary:
        Average: 1544 ms
        Max: 2548.972 ms
        Min: 929.602 ms
      Counter: 6450
```

Pool implementation:
```
15:57:01.404 [info]  Telemetry report 2021-09-24 13:57:01.403792Z:
  Event [:event, :finished]
    Measurement "duration"
      Summary:
        Average: 225 ms
        Max: 341.8 ms
        Min: 117.861 ms
      Counter: 6337
```

Where `Counter` is the number of events treated per minute, and `Summary` gives
the average duration each message takes from the producer to the end of the
pipeline.

## Conclusion

Both implementations have sensibly the same throughput. I don't understand why
there are such big latency differences though, I suspect a bug in the way I
measure the durations, but couldn't figure out the issue.

This was an interesting experiment, I learned how to setup Telemetry, poolboy,
and got a better understanding of GenStage. Also this is good news since I can
stick to my `Broadway` implementation and not reinvent the wheel!
