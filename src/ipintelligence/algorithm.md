@page IpIntelligence_Algorithm IP Intelligence Algorithm

# IP Intelligence Algorithm

51Degrees IP Intelligence uses a tree-based algorithm for IP address geolocation and network identification.

## Core Algorithm Design

### Tree Forest Data Structure

The algorithm uses a **forest of trees** to efficiently evaluate IP addresses:

- **Nodes**: Fixed-width records with bit-packed data containing value, span index, and navigation flags
- **Spans**: Define IP address ranges with variable bit lengths supporting both IPv4 (32-bit) and IPv6 (128-bit)
- **Clusters**: Group nodes for efficient traversal with 256 span index mappings enabling binary search optimization

### Evaluation Process

The algorithm performs **bit-by-bit traversal** of IP addresses:

1. **Initialization**: Position cursor at graph root entry
2. **Bit processing**: Traverse IP address bits from most to least significant  
3. **Span comparison**: Compare current IP bits against span limits
4. **Navigation**: Select path based on comparison results (less than, equal, between, greater than)
5. **Termination**: Continue until leaf node found or IP bits exhausted

### Performance Optimizations

- **Binary search** on clustered nodes for logarithmic complexity
- **Bit manipulation** with efficient packed data structures
- **Lazy loading** of spans and clusters to minimize memory usage
- **Memory-efficient** collections with proper cleanup

## Technical Characteristics

- **Variable-length spans** for optimal space utilization
- **Comprehensive tracing** system for debugging and validation
- **Support for both file and memory-based data sources**