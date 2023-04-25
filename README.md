# SwiftyPID
 
This is a project for me to gain exposure to control theory and working with PID control elements.

The project is structured in two parts:

The Swift Playground, where you can interactively test and observe different aspects of the simulation.
The Xcode project, where the main development work takes place.

#### Spinner

The spinner is the initial proof-of-concept for applying thrust at either end of a bar and simulating the application of calculated torque. You can adjust the angular inertia of the spinner using the dampening property. This helps to provide an understanding of how the torque affects the drone's spinning behavior.

 #### PID Controlled Drone

The main part of the project is the PID controlled drone. It consists of three separate PID controllers with sliders to control the x, y, and orientation parameters independently. By adjusting these sliders, you can observe the effects of changing each parameter live, which helps to understand the impact of tuning the PID controllers.
