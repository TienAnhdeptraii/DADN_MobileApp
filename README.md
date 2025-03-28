# iFarm

A Flutter mobile app for farm AIoT system.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## API Specifications

### Humidity Data API
#### 1. Get all data 
- **Endpoint**: **GET** `https://io.adafruit.com/api/v2/huynhat/feeds/v2/data`
- **Response:**
```json
[
    {
        "id": "0FV9GNTT6498GFDNF4NXTWD4HP",
        "value": "49.7",
        "feed_id": 3018473,
        "feed_key": "v2",
        "created_at": "2025-03-27T07:37:59Z",
        "created_epoch": 1743061079,
        "expiration": "2025-04-26T07:37:59Z"
    },
    {
        "id": "0FV9GNHFYEHYH7N4BATA45BEDK",
        "value": "49.8",
        "feed_id": 3018473,
        "feed_key": "v2",
        "created_at": "2025-03-27T07:37:29Z",
        "created_epoch": 1743061049,
        "expiration": "2025-04-26T07:37:29Z"
    },
    {
        "id": "0FV9GN88PKDZD9CFF2AWH57QY6",
        "value": "49.7",
        "feed_id": 3018473,
        "feed_key": "v2",
        "created_at": "2025-03-27T07:36:59Z",
        "created_epoch": 1743061019,
        "expiration": "2025-04-26T07:36:59Z"
    }
]
```
- **Description**: Return a data list which starts from the most recent data. 

#### 2. Get last data
- **Endpoint**: **GET** `https://io.adafruit.com/api/v2/huynhat/feeds/v2/data/last`
- **Response:**
```json
{
    "id": "0FV9GNTT6498GFDNF4NXTWD4HP",
    "feed_id": 3018473,
    "value": "49.7",
    "location": null,
    "created_at": "2025-03-27T07:37:59Z",
    "updated_at": "2025-03-27T07:37:59Z",
    "expiration": "1745653079.0",
    "lat": null,
    "lon": null,
    "ele": null
}
```
- **Description**: Return the most recent data. 

#### 3. Get data with filter (Date and Time)
- **Endpoint**: **GET** `https://io.adafruit.com/api/v2/huynhat/feeds/v2/data?start_time={startTime}&end_time={endTime}`
- **Input Format**: `yyyy-MM-dd<T>HH:mm:ss<Z>`
- **Format Explanation**: **Date** and **Time** are seperated by letter `T`. The letter `Z` at the end of **Time** part means Zulu Time (GMT 0), so converting your current time zone to Zulu Time is necessary.
- **Example**: `https://io.adafruit.com/api/v2/huynhat/feeds/v1/data?start_time="2025-03-19T05:17:22Z"&end_time="2025-03-24T05:31:52Z"` will return all humidity data from `12:17:22 19-03-2025` to `12:31:52 19-03-2025` in GMT+7.
- **Response**: same as `Get all data`.

### Temperature Data API
#### 1. Get all data 
- **Endpoint**: **GET** `https://io.adafruit.com/api/v2/huynhat/feeds/v1/data`
- **Response:**
```json
[
    {
        "id": "0FV9GNTT5VRXW08W22ZSAC988Y",
        "value": "25.8",
        "feed_id": 3018474,
        "feed_key": "v1",
        "created_at": "2025-03-27T07:37:59Z",
        "created_epoch": 1743061079,
        "expiration": "2025-04-26T07:37:59Z"
    },
    {
        "id": "0FV9GNHFWNVXDV1BGVQ9MN44WV",
        "value": "25.8",
        "feed_id": 3018474,
        "feed_key": "v1",
        "created_at": "2025-03-27T07:37:29Z",
        "created_epoch": 1743061049,
        "expiration": "2025-04-26T07:37:29Z"
    },
    {
        "id": "0FV9GN88PPVD7SNDEX2X4M0SEJ",
        "value": "25.8",
        "feed_id": 3018474,
        "feed_key": "v1",
        "created_at": "2025-03-27T07:36:59Z",
        "created_epoch": 1743061019,
        "expiration": "2025-04-26T07:36:59Z"
    }
]
```
- **Description**: Return a data list which starts from the most recent data. 

#### 2. Get last data
- **Endpoint**: **GET** `https://io.adafruit.com/api/v2/huynhat/feeds/v1/data/last`
- **Response:**
```json
{
    "id": "0FV9GNTT5VRXW08W22ZSAC988Y",
    "feed_id": 3018474,
    "value": "25.8",
    "location": null,
    "created_at": "2025-03-27T07:37:59Z",
    "updated_at": "2025-03-27T07:37:59Z",
    "expiration": "1745653079.0",
    "lat": null,
    "lon": null,
    "ele": null
}
```
- **Description**: Return the most recent data. 

#### 3. Get data with filter (Date and Time)
- **Endpoint**: **GET** `https://io.adafruit.com/api/v2/huynhat/feeds/v1/data?start_time={startTime}&end_time={endTime}`
- **Input Format**: `yyyy-MM-dd<T>HH:mm:ss<Z>`
- **Format Explanation**: **Date** and **Time** are seperated by letter `T`. The letter `Z` at the end of **Time** part means Zulu Time (GMT 0), so converting your current time zone to Zulu Time is necessary.
- **Example**: `https://io.adafruit.com/api/v2/huynhat/feeds/v1/data?start_time="2025-03-19T05:17:22Z"&end_time="2025-03-24T05:31:52Z"` will return all humidity data from `12:17:22 19-03-2025` to `12:31:52 19-03-2025` in GMT+7.
- **Response**: same as `Get all data`.

### Pump Control API

#### Turn on/off

- **Endpoint**: **POST** `https://io.adafruit.com/api/v2/huynhat/feeds/v3/data`
- **Header**:
```json
{
    "X-AIO-Key": "Owner_API_Key"
}
```
- **Request body**:
```json
{
    "value": " "1" for On and "0" for Off "
}
```
