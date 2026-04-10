# Week 5 Thursday: Reflection and Engineering Thinking

## Question 1: Docker Agent Isolation in Depth

Three approaches to add `libvips` to `node:18-alpine`:

### Approach 1: Install via apk in Pipeline (Quickest)
```groovy
stage('Install Dependencies') {
    steps {
        sh 'apk add --no-cache libvips'
        sh 'npm ci'
    }
}
