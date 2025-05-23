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
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity`
- **Response:**
```json
[
    {
        "value": "49.7",
        "id": "0FV9GNTT6498GFDNF4NXTWD4HP",
        "description": "Medium",
        "time": "07:37:59",
        "date": "2025-03-27"
    },
    {
        "value": "49.8",
        "id": "0FV9GNHFYEHYH7N4BATA45BEDK",
        "description": "Medium",
        "time": "07:37:29",
        "date": "2025-03-27"
    },
    {
        "value": "49.7",
        "id": "0FV9GN88PKDZD9CFF2AWH57QY6",
        "description": "Medium",
        "time": "07:36:59",
        "date": "2025-03-27"
    }
]
```
- **Description**: Return a data list which starts from the most recent data. 

#### 2. Get most recent data
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity/recent`
- **Response:** A String of value: `"49.7"`
- **Description**: Return the most recent data. 

#### 3. Get data with filter (Date and Time)
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity/filter?start_time={startTime}&end_time={endTime}`
- **Input Format**: `yyyy-MM-dd<T>HH:mm:ss`
- **Format Explanation**: `DateTime` is now GMT+7. You don't need to convert it to Zulu.
- **Example**: `https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity/filter?start=2025-03-19T05:17:22&end=2025-03-24T05:31:52` will return all humidity data from `12:17:22 19-03-2025` to `12:31:52 19-03-2025` in GMT+7.
- **Response**: same as `Get all data`.

### Temperature Data API
#### 1. Get all data 
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature`
- **Response:**
```json
[
    {
        "value": "25.8",
        "id": "0FV9GNTT5VRXW08W22ZSAC988Y",
        "description": "Medium",
        "time": "07:37:59",
        "date": "2025-03-27"
    },
    {
        "value": "25.8",
        "id": "0FV9GNHFWNVXDV1BGVQ9MN44WV",
        "description": "Medium",
        "time": "07:37:29",
        "date": "2025-03-27"
    },
    {
        "value": "25.8",
        "id": "0FV9GN88PPVD7SNDEX2X4M0SEJ",
        "description": "Medium",
        "time": "07:36:59",
        "date": "2025-03-27"
    }
]
```
- **Description**: Return a data list which starts from the most recent data. 

#### 2. Get last data
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature/recent`
- **Response:** A String of value: `"25.8"`
- **Description**: Return the most recent data. 

#### 3. Get data with filter (Date and Time)
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature/filter?start={startTime}&end={endTime}`
- **Input Format**: `yyyy-MM-dd<T>HH:mm:ss`
- **Format Explanation**: `DateTime` is now GMT+7. You don't need to convert it to Zulu.
- **Example**: `https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature/filter?start=2025-03-19T05:17:22&end=2025-03-24T05:31:52` will return all humidity data from `12:17:22 19-03-2025` to `12:31:52 19-03-2025` in GMT+7.
- **Response**: same as `Get all data`.

### Pump Control API
#### 1. Get watering history
- **Endpoint**: **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/water`

- **Response**:
```json
[
     {
        "time": "05:24:21",
        "date": "2025-03-19",
        "duration": "192:44:01"
    },
    {
        "time": "06:08:26",
        "date": "2025-03-27",
        "duration": "00:00:03"
    },
    {
        "time": "06:13:28",
        "date": "2025-03-27",
        "duration": "00:00:04"
    }
]
```

#### 2. Turn on/off water pump
- **Endpoint**: **POST** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump/{state}`
- **Description**: `state` has value of `1 for ON` or `0 for OFF`. 
- **Response**:
```json
{
    "status": 1,
    "message": "Set pump status to: ON"
}
```
```json
{
    "status": 0,
    "message": "Set pump status to: OFF"
}
```

#### 3. Turn on/off auto mode
- **Endpoint** (Turn on): **POST** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump/auto/enable`
- **Endpoint** (Turn off): **POST** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump/auto/disable`
- **Response**: A String of message `"Auto mode is enabled"` or `"Auto mode is disabled"`

#### 4. Get water statistics
- **Endpoint:** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/statistics`
- **Response:**
```json
{
    "duration": "02:00:00", 
    "waterConsumption": 10.7, 
    "waterTimes": 20 
}
```
- **Description**: `duration` is total duration water use in a day. `waterConsumption` is water usage in a day in m3. `waterTimes` is the times system waters the plants.

#### 5. Get pump status
- **Endpoint:** **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/water/pump`
- **Response:**
```json
{
    "status": "0 or 1 (int)"
    "message": "Current pump status: 0 or 1"
}
```

### Prediction API
#### 1. Humidity prediction
- **Endpoint:** **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/predictions/humidity/{steps}`
- **Description:** `steps` is period of time we want to predict (time unit is hour).
- **Response**:
  ```json
  [
      {
          "dateTime": "2025-04-21T19:00:00",
          "data": 27.45147787981353,
          "description": "Medium"
      },
      {
          "dateTime": "2025-04-21T20:00:00",
          "data": 27.158026000026975,
          "description": "Medium"
      },
      {
          "dateTime": "2025-04-21T21:00:00",
          "data": 26.700214306639978,
          "description": "Medium"
      },
  ]
  ```

#### 2. Temperature prediction
- **Endpoint:** **GET** `https://adapting-doe-precious.ngrok-free.app/ifarm-be/predictions/temperature/{steps}`
- **Description:** same as `1`
- **Response**: same as `1`
