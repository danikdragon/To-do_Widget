cmake_minimum_required(VERSION 3.16)

project(To-Do VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick REQUIRED)

qt_add_executable(appTo-Do
    main.cpp
)

qt_add_qml_module(appTo-Do
    URI To-Do
    VERSION 1.0
    QML_FILES main.qml
    QML_FILES Sticker.qml
    QML_FILES PngSticker.qml
)

set_target_properties(appTo-Do PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTo-Do
    PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS appTo-Do
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
