FROM openjdk:8
MAINTAINER Dimitris Garofalakis<dimitris.garofalakis@atcom.gr>


RUN export ANDROID_COMPILE_SDK="28"
RUN export ANDROID_BUILD_TOOLS="28.0.3"
RUN export VERSION_SDK_TOOLS="4333796"
RUN export GRADLE_USER_HOME=/cache/.gradle

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip
RUN unzip android-sdk.zip -d ./android-sdk-linux
RUN export ANDROID_HOME=$PWD/android-sdk-linux
RUN export PATH=$PATH:$PWD/android-sdk-linux/platform-tools/
RUN mkdir "android-sdk-linux/licenses" || true
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > "android-sdk-linux/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > "android-sdk-linux/licenses/android-sdk-preview-license"
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "add-ons;addon-google_apis-google-24" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;android;m2repository" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;google;m2repository" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;google;google_play_services" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" > /dev/null 2>&1
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update
RUN chmod +x ./gradlew
RUN ./gradlew test
