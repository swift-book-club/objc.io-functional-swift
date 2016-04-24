//:## Addressing a Claim from Chapter 2
//:### “Furthermore, it is worth pointing out that we cannot inspect how a region was constructed: is it composed of smaller regions? Or is it simply a circle around the origin? The only thing we can do is to check whether a given point is within a region or not. If we want to visualize a region, we would have to sample enough points to generate a (black and white) bitmap.
//:### In a later chapter, we will sketch an alternative design that will allow you to answer these questions.”

import Cocoa

struct Position {
    let x: Double
    let y: Double

    init() {
        self.x = 0
        self.y = 0
    }

    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
}

struct Vector {
    let dx: Double
    let dy: Double
    init(_ dx: Double, _ dy: Double) {
        self.dx = dx
        self.dy = dy
    }
}

infix operator - { associativity left }
func -(point: Position, vector: Vector) -> Position {
    return Position(point.x - vector.dx, point.y - vector.dy)
}

enum Region {
    case Circle(radius: Double)
    indirect case Shift(Vector, Region)
    indirect case Invert(Region)
    indirect case Intersection(Region, Region)
    indirect case Union(Region, Region)
    indirect case Difference(Region, Region)

    func isPointInside(point: Position) -> Bool {
        switch self {
        case let .Circle(radius):
            return sqrt(point.x * point.x + point.y * point.y) <= radius

        case let .Shift(offset, region):
            return region.isPointInside(point - offset)

        case let .Invert(region):
            return !region.isPointInside(point)

        case let .Intersection(region1, region2):
            return region1.isPointInside(point) && region2.isPointInside(point)

        case let .Union(region1, region2):
            return region1.isPointInside(point) || region2.isPointInside(point)
            
        case let .Difference(region1, region2):
            return Region.Intersection(region1, .Invert(region2)).isPointInside(point)
        }
    }
}

infix operator ∩ { associativity left }
func ∩(region1: Region, region2: Region) -> Region {
    return Region.Intersection(region1, region2)
}

infix operator ∪ { associativity left }
func ∪(region1: Region, region2: Region) -> Region {
    return Region.Union(region1, region2)
}

infix operator → { associativity left }
func →(region: Region, vector: Vector) -> Region {
    return Region.Shift(vector, region)
}

func -(region1: Region, region2: Region) ->  Region {
    return Region.Difference(region1, region2)
}


//:## Test it!
//:### Use `assert` as a simple testing mechanism.
//:##### Going to be making and testing this region:

let image = [#Image(imageLiteral: "region diagram.png")#]
let outerCircle = Region.Circle(radius: 5)

assert(outerCircle.isPointInside(Position()))
assert(!outerCircle.isPointInside(Position(10, 20)))

let ring = outerCircle - Region.Circle(radius: 3)

assert(!ring.isPointInside(Position()))
assert(ring.isPointInside(Position(4, 0)))

let shiftedRing = ring → Vector(6, 12)

assert(!shiftedRing.isPointInside(Position()))
assert(!shiftedRing.isPointInside(Position(6, 12)))
assert(shiftedRing.isPointInside(Position(6, 8)))

let centerOfFriendly = Vector(8, 9)
let friendlyZone = Region.Circle(radius: 2) → centerOfFriendly

let shiftedMinusFriendly = shiftedRing - friendlyZone
assert(shiftedMinusFriendly.isPointInside(Position(6, 8)))
assert(!shiftedMinusFriendly.isPointInside(Position(8, 9)))

print(shiftedMinusFriendly)

extension Region: CustomStringConvertible {
    var description: String {
        switch self {
        case let .Circle(radius):
            return "circle with radius \(radius)"

        case let .Shift(offset, region):
            return "[\(region)] shifted by (\(offset.dx), \(offset.dy))"

        case let .Invert(region):
            return "[\(region)] inverted"

        case let .Intersection(region1, region2):
            return "intersection of [\(region1)] and [\(region2)]"

        case let .Union(region1, region2):
            return "union of [\(region1)] and [\(region2)]"

        case let .Difference(region1, region2):
            return "difference between [\(region1)] and [\(region2)]"
        }
    }
}

let description = shiftedMinusFriendly.description

