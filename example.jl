using Parameters

@with_kw mutable struct CircularBuffer

    items::Array{Array{Any,1},1} = []
    capacity::Int = 0
    occupancy::Int = 0
    order::Int = 0
    oldestOrder = nothing

end



function read(buff::CircularBuffer)
    if buff.occupancy == 0
        throw(Exception("The circular buffer is empty."))
    end


    i = 1
    oldest_fnd = false

    while !oldest_fnd
        if buff.items[i][2] == buff.oldestOrder
            oldest_fnd = true
            value = buff.items[i][1]
            buff.items[i] = [nothing, nothing]
            buff.oldestOrder += 1
            buff.occupancy -= 1

            return value
        else
            i += 1
        end
    end
end



function write(buff::CircularBuffer, data)

    if buff.capacity > length(buff.items)
        diff = buff.capacity - length(buff.items)
        for i = 1 : diff
            push!(buff.items, [nothing, nothing])
        end
    end

    if buff.occupancy == length(buff.items)
        throw(Exception("CircularBuffer at full occupancy!"))
    end



    buff.order += 1
    if buff.order == 1;    buff.oldestOrder = 1;    end


    i = 1
    empty_slot_fnd = false
    while i ≤ length(buff.items)  &&  !empty_slot_fnd
        if buff.items[i][1] == nothing
            empty_slot_fnd = true
            buff.items[i] = [data, buff.order]
            buff.occupancy += 1
        else
            i += 1
        end
    end

end



function overwrite(buff::CircularBuffer, data)
    if buff.occupancy == length(buff.items)
        i = 1
        oldest_fnd = false

        while !oldest_fnd
            if buff.items[i][2] == buff.oldestOrder
                oldest_fnd = true
                buff.order += 1
                buff.items[i] = [data, buff.order]
                buff.oldestOrder += 1
            else
                i += 1
            end
        end
    else
        if buff.occupancy == length(buff.items)
            throw(Exception("CircularBuffer at full occupancy!"))
        end

        buff.order += 1
        if buff.order == 1;    buff.oldestOrder = 1;    end

        i = 1
        empty_slot_fnd = false
        while i ≤ length(buff.items)  &&  !empty_slot_fnd
            if buff.items[i][1] == nothing
                empty_slot_fnd = true
                buff.items[i] = [data, buff.order]
                buff.occupancy += 1
            else
                i += 1
            end
        end

    end
end



function clear(buff::CircularBuffer)
    if buff.occupancy > 0
        i = 1
        oldest_fnd = false

        while !oldest_fnd
            if buff.items[i][2] == buff.oldestOrder
                oldest_fnd = true
                buff.items[i] = [nothing, nothing]
                buff.oldestOrder += 1
                buff.occupancy -= 1
            else
                i += 1
            end
        end
    end
end



function str(buff::CircularBuffer)
    output = ""

    for item in buff.items
        if item == [nothing, nothing]
            output *= "[,]" * "\n"
        else
            output *= string(item) * "\n"
        end
    end

    output *= "\n"

    if buff.oldestOrder == nothing
        output *= "Oldest order is *nothing*"
    else
        output *= "Oldest order is " * string(buff.oldestOrder)
    end



    return output
end
