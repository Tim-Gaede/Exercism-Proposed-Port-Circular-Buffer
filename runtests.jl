using Test

include("circular_buffer.jl")

# Tests adapted from `problem-specifications//canonical-data.json` @ v1.2.0
println("\n"^2, "-"^60, "\n"^3)



@testset "Reading empty CircularBuffer should fail." begin
    buff = CircularBuffer(capacity=1)
    @test_throws Exception read(buff)
end
println()

@testset "Can read an item just written." begin
    buff = CircularBuffer(capacity=1)
    write(buff, "1")
    @test read(buff) == "1"
end
println()

@testset "Each item may only be read once." begin
    buff = CircularBuffer(capacity=1)
    write(buff, "1")
    @test read(buff) == "1"
    @test_throws Exception read(buff)
end
println()


@testset "Items are read in the order they are written." begin
    buff = CircularBuffer(capacity=2)
    write(buff, "1")
    write(buff, "2")
    @test read(buff) == "1"
    @test read(buff) == "2"
end
println()


@testset "Full CircularBuffer cannot be written to." begin
    buff = CircularBuffer(capacity=1)
    write(buff, "1")
    @test_throws Exception write(buff, "2")
end
println()


@testset "A read frees up capacity for another write." begin
    buff = CircularBuffer(capacity=1)
    write(buff, "1")
    @test read(buff) == "1"
    write(buff, "2")
    @test read(buff) == "2"
end
println()


@testset "Read position is maintained even across multiple writes." begin
    buff = CircularBuffer(capacity=3)
    write(buff, "1")
    write(buff, "2")
    @test read(buff) == "1"
    write(buff, "3")
    @test read(buff) == "2"
    @test read(buff) == "3"
end
println()


@testset "Items cleared out of CircularBuffer can t be read." begin
    buff = CircularBuffer(capacity=1)
    write(buff, "1")
    clear(buff)
    @test_throws Exception read(buff)
end
println()


@testset "Clear frees up capacity for another write." begin
    buff = CircularBuffer(capacity=1)
    write(buff, "1")
    clear(buff)
    write(buff, "2")
    @test read(buff) == "2"
end
println()


@testset "Clear does nothing on empty CircularBuffer." begin
    buff = CircularBuffer(capacity=1)
    clear(buff)
    write(buff, "1")
    @test read(buff) == "1"
end
println()


@testset "Overwrite acts like write on non full CircularBuffer." begin
    buff = CircularBuffer(capacity=2)
    write(buff, "1")
    overwrite(buff, "2")
    @test read(buff) == "1"
    @test read(buff) == "2"
end
println()


@testset "Overwrite replaces the oldest item on full CircularBuffer." begin
    buff = CircularBuffer(capacity=2)
    write(buff, "1")
    write(buff, "2")
    overwrite(buff, "3")
    @test read(buff) == "2"
    @test read(buff) == "3"
end
println()


@testset "Overwrite replaces the oldest item remaining in CircularBuffer following a read." begin
    buff = CircularBuffer(capacity=3)
    write(buff, "1")
    write(buff, "2")
    write(buff, "3")
    @test read(buff) == "1"
    write(buff, "4")
    overwrite(buff, "5")
    @test read(buff) == "3"
    @test read(buff) == "4"
    @test read(buff) == "5"
end
println()


@testset "Initial clear does not affect wrapping around." begin
    buff = CircularBuffer(capacity=2)
    clear(buff)
    write(buff, "1")
    write(buff, "2")
    overwrite(buff, "3")
    overwrite(buff, "4")
    @test read(buff) == "3"
    @test read(buff) == "4"
    @test_throws Exception read(buff)
end
println()
